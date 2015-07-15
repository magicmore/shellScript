#!/usr/bin/bash

scriptName="buildagent"
manPage=$scriptName".1"
searchPath=$1
function openFile
{
	if [[ -e $scriptName ]]
	then 
		rm -f $scriptName
	fi
	touch $scriptName
	exec 3>&1
	exec 1>$scriptName
}
function writeHead
{
	printf "#!/bin/sh\n"
	printf "source func.sh\n"
	printf 'projectName=$(echo $1| tr "A-Z" "a-z")\n'
	printf 'case $projectName in\n'
}

function writeBody
{
	lowCaseVar=$(echo $1|tr 'A-Z' 'a-z')
	printf "\t--%s)\n" $lowCaseVar
	printf '\t\tProjectPath="%s"\n' $2
	printf '\t\texecBuildCmd $2 $ProjectPath\n'
	printf '\t\t;;\n'
}

function writeTail
{
	printf "\t*)\n"
	printf "\t\techo 'Error Input Option. Please input branch option as following:'\n"
	printf "\t\techo '--%s'\n" $(echo $@ | tr 'A-Z' 'a-z')
	printf "\t\t;;\n"
	printf "esac"
}
function createManPage
{
	exec 1>$manPage
	printf ".TH buildAgent\n"
	printf ".SH Description\nbuildagent is a convenient way to call build script of CCA.\n"
	printf ".SH Usage\n buildagent [branch] [build]\n"
	printf ".SH Example\n buildagent --agent_main --ut_all\n"
	printf ".SH Option branch.\n"
	printf "\\\\fI%s\\\\fR\n" $(echo $@ | tr 'A-Z' 'a-z')
	printf ".SH Option build.\n"
	printf "\\\\fIut_all\\\\fR call test/UniversalTest/CCA/BuildAll.\n.TP\n"
	printf "\\\\fIut_cca\\\\fR call test/UniversalTest/CCA/PureCCA/cca_lib/go.\n.TP\n"
	printf "\\\\fIut_ipstb\\\\fR call test/UniversalTest/CCA/IPSTB_CCA_COMMON/cca_lib/go\n.TP\n"
	printf "\\\\fIut_anti\\\\fR call test/UniversalTest/CCA/IPSTB_CCA_DISABLE_ANTI_FLASH_COPY/cca_lib/go\n.TP\n"
	printf "\\\\fIut_con\\\\fR call test/UniversalTest/CCA/ConvergentClient/cca_lib/go\n.TP\n"
	printf "\\\\fIhst_cca\\\\fR  call platform/Windows/build/vc_10.0.30319.1_x86/go\n.TP\n"
	printf "\\\\fIhst_ipstb\\\\fR  call platform/Windows/build/vc_10.0.30319.1_x86_Ipstb/go\n.TP\n"
}
openFile
locPattern='/platform/Windows/build/vc_10.0.30319.1_x86/build_cloakedcaagent_dll.bat';
writeHead
i=0
while read -r url
do
	if echo $url | grep -q "$locPattern"
	then 
		pathLoc=${url%$locPattern}
		writeBody ${pathLoc##*/} $pathLoc
		projectName[$i]=${pathLoc##*/}
		((i++))
	fi
done< <(find ${searchPath:-.} -name "build_cloakedcaagent_dll.bat")

writeTail ${projectName[*]}
createManPage ${projectName[*]}
if [[ -e $manPage.gz ]]
then 
	rm $manPage.gz
fi
gzip $manPage
mv -f $manPage.gz /usr/share/man/man1/
chmod +x $scriptName

exec 1>&3
printf ">>>>>>>>> %d projects detected. <<<<<<<<<\n" ${#projectName[@]}
for ((i=0; i<${#projectName[@]}; i++))
do
	printf "%s\n" ${projectName[$i]}
done


