function buildHst
{
	HstBuildPath=${1}/platform/Windows/build
	buildScriptPath=$2
	cd "${HstBuildPath}/$buildScriptPath"
	echo "Enter: "$PWD
	./go
}

function buildUt
{
	UtBuildPath=${1}/test/UniversalTest/CCA
	buildScriptPath=$2
	cd "${UtBuildPath}/$buildScriptPath"
	echo "Enter: "$PWD
	if [ -e ./go ]
	then
		./go
	else
		./BuildAll
	fi

}

function execBuildCmd
{
	echo $1 $2
	buildOptionLowCase=$(echo $1| tr 'A-Z' 'a-z')
	projectPath=$2
	case $buildOptionLowCase in 
	--ut_all)
		buildUt $projectPath
		;;
	--ut_cca)
		buildUt $projectPath "PureCCA/cca_lib"
		;;
	--ut_ipstb)
		buildUt $projectPath "IPSTB_CCA_COMMON/cca_lib"
		;;
	--ut_anti)
		buildUt $projectPath "IPSTB_CCA_DISABLE_ANTI_FLASH_COPY/cca_lib"
		;;
	--ut_con)
		buildUt $projectPath "ConvergentClient/cca_lib"
		;;		
	--hst_cca)
		buildHst $projectPath "vc_10.0.30319.1_x86"
		;;
	---hst_ipstb)
		buildHst $projectPath "vc_10.0.30319.1_x86_Ipstb"
		;;
	*)
		echo "Error option input. Please input as following input opton."
		echo "--ut_all"
		echo "--ut_cca"
		echo "--ut_ipstb"
		echo "--ut_anti"
		echo "--ut_con"
		echo "--hst_cca"
		echo "--hst_ipstb"
	esac
}