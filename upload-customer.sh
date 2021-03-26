#!/bin/bash

unamestr=`uname`

if [[ "$unamestr" = MINGW* || "$unamestr" = "Linux" ]]; then
    	SED="sed"
elif [ "$unamestr" = "Darwin" ]; then
    	SED="gsed"
else
    	echo "only Linux, MingW or Mac OS can be supported" &
    	exit 1
fi

cd ..

BASEDIR="E:/work/sdk/"
OUTDIR=${BASEDIR}/"kfsdkdownload"
#OUTDIR=${BASEDIR}/"sdkTest"
FILE_LENGTH_DIR="fileinfo"
AVDIR=$OUTDIR/av
LITEDIR=$OUTDIR/lite
TAIBAODIR=$OUTDIR/taibao
AGENTDIR=$OUTDIR/agent

dir=($OUTDIR $AVDIR $LITEDIR $TAIBAODIR $AGENTDIR)
for i in ${dir[@]}
do
	if [[ ! -d $i ]];then
		mkdir $i
	fi
done

function log_print() {
	echo -e "\n------------------------------------------------------------------"
	echo "----------------- $1 -----------------"
	echo -e "------------------------------------------------------------------ \n\n"
}
baseUrl=https://bintray.com/easemobkefu/maven/download_file?file_path=com/easemob/
sdk_version_array=("1.1.5" "1.1.6" "1.1.7" "1.1.7.final" "1.1.8" "1.1.8.taibao" "1.1.9" "1.1.9r2" "1.2.0" "1.2.1" "1.2.2" "1.2.3" "1.2.4" "1.2.5")
sdk_lite_version_array=("1.1.5" "1.1.6" "1.1.6.final" "1.1.7" "1.1.7.final" "1.1.8" "1.1.8.final" "1.1.8.debug" "1.1.8.debug2" "1.1.9" "1.1.9r2" "1.2.0" "1.2.1" "1.2.2" "1.2.3" "1.2.4" "1.2.5" "1.2.5.1")
sdk_taibao_version_array=("1.0.0" "1.0.1" "1.0.2" "1.0.3" "1.0.4" "1.0.5" "1.0.6" "1.0.7" "1.0.9" "1.1.1" "1.1.2" "1.1.3" "1.1.4" "1.1.5" "1.1.5.beta" "1.1.6" "1.1.7" "1.1.8" "1.1.9" "1.1.10" "1.1.11" "1.1.12" "1.1.13" "1.1.14" "1.1.15" "1.2.0" "1.2.0.1" "1.2.0.2" "1.2.1" "1.2.1.1" "1.2.2" "1.2.2.1" "1.2.3" "1.2.4" "1.2.4.1" "1.2.4.2" "1.2.5" "1.2.6")
agentsdk_version_array=("1.0.3" "1.0.4" "1.0.5" "1.0.9" "1.0.9r2")
file_type_arry=("-javadoc.jar" "-sources.jar" ".aar" ".pom")
project_name_arry=("kefu-sdk" "kefu-sdk-lite" "kefu-sdk-taibao" "kefu-agentsdk-android")


#<groupId>com.hyphenate</groupId>

function gpgFiles() {
  echo "prepare to gpg file: $1"
  #如果存在asc文件，则先删除
  if [[ -e $1.asc ]]; then
    echo "exist asc file:$1.asc"
    rm $1.asc
  fi
  if [[ "$unamestr" = MINGW* ]]; then
    D\:\\ProgramFiles\(x86\)\\GnuPG\\bin\\gpg.exe -ab $1
  fi
  echo "gpg file: $1 end"
}

function makeDir() {
  if [[ ! -d $1 ]];then
		mkdir $1
	fi
}

function makeFile() {
  if [[ ! -f $1 ]];then
		touch $1
	fi
}

function replaceInfoToMavenCenter() {
  if [[ -e $file ]];then
    log_print "start replaceInfoToMavenCenter file: $filename"
    #需要校验文件大小是否与返回的文件大小一致
    #$SED -i 's/<groupId>com.hyphenate<\/groupId>/<groupId>io.hyphenate<\/groupId>/' $file
    if [[ $filename == *"kefu-sdk-lite"* ]]; then
      echo "执行这里了 kefu-sdk-lite"
      grep -sq "<description>" $file
      if [ $? != 0 ]; then
        echo "没有找到相关内容"
        $SED -i 's/\(<name>kefu-sdk-lite<\/name>\)/\1\n\t<description>kefu lite SDK.<\/description>/' $file
      else
        echo "找到相关内容"
        $SED -i 's/.*description.*/\t<description>kefu lite SDK.<\/description>/' $file
      fi
    elif [[ $filename == *"kefu-sdk-taibao"* ]]; then
       echo "执行这里了 kefu-sdk-taibao"
      grep -sq "<description>" $file
      if [ $? != 0 ]; then
        echo "没有找到相关内容"
        $SED -i 's/\(<name>kefu-sdk-taibao<\/name>\)/\1\n\t<description>taibao kefu SDK.<\/description>/' $file
      else
        echo "找到相关内容"
        $SED -i 's/.*description.*/\t<description>taibao kefu SDK.<\/description>/' $file
      fi
    elif [[ $filename == *"kefu-agentsdk-android"* ]]; then
       echo "执行这里了 kefu-agentsdk-android"
       grep -sq "<description>" $file
      if [ $? != 0 ]; then
        echo "没有找到相关内容"
        $SED -i 's/\(<name>kefu-agentsdk-android<\/name>\)/\1\n\t<description>kefu agent SDK.<\/description>/' $file
      else
        echo "找到相关内容"
        $SED -i 's/.*description.*/\t<description>kefu agent SDK.<\/description>/' $file
      fi
    else
      grep -sq "<description>" $file
      if [ $? != 0 ]; then
        echo "没有找到相关内容"
        $SED -i 's/\(<name>kefu-sdk.*name>\)/\1\n\t<description>kefu sdk.<\/description>/' $file
      else
        echo "找到相关内容"
        $SED -i 's/.*description.*/\t<description>kefu sdk.<\/description>/' $file
      fi
    fi
    $SED -i 's/<id>easemobkefu<\/id>/<id>shanjingheng<\/id>/' $file
    $SED -i 's/<name>easemob<\/name>/<name>Sean<\/name>/' $file
    $SED -i 's/.*@easemob.com.*email.*/\t\t<email>shanjingheng@sohu.com<\/email>/' $file
    log_print "end replaceInfoToMavenCenter file: $filename"
  fi
}

function generateBundleFile() {
  log_print "generateBundleFile start"
  pomFile=${versionName}${file_type_arry[0]}
  javadocFile=${versionName}${file_type_arry[1]}
  sourcesFile=${versionName}${file_type_arry[2]}
  aarFile=${versionName}${file_type_arry[3]}
  bundleFile=${versionName}-bundle.jar
  echo "before bundle pomFile: $pomFile \n javadocFile: $javadocFile \n sourcesFile: $sourcesFile \n aarFile: $aarFile \n bundleFile: $bundleFile"
  if [[ -e $bundleFile ]];then
    echo "$bundleFile exist, should delete"
    rm $bundleFile
    echo "delete $bundleFile finish"
  fi
  #如果是windows环境下
  if [[ "$unamestr" = MINGW* ]]; then
    ${JAVA_HOME}/bin/jar.exe -cvf ${bundleFile}\
    $pomFile ${pomFile}.asc\
    $aarFile ${aarFile}.asc\
    $javadocFile ${javadocFile}.asc\
    $sourcesFile ${sourcesFile}.asc
  else
    jar -cvf ${bundleFile}\
    $pomFile ${pomFile}.asc\
    $aarFile ${aarFile}.asc\
    $javadocFile ${javadocFile}.asc\
    $sourcesFile ${sourcesFile}.asc
  fi
  log_print "generateBundleFile end"
}

function uploadBundleToMavenCenter() {
  log_print "prepare upload bundleFile: $bundleFile"
  #下面的用户名是指sonatype UI中profile中的userToken中的username和password
  httpCode=$(curl  -v -u 用户名:密码 --request POST -F "file=@${bundleFile}" -w %{http_code} https://oss.sonatype.org/service/local/staging/bundle_upload)
  echo "httpCode: $httpCode"
  #检查是否上传成功，如果相应头中没有包含201，则认为失败
  if [[ $httpCode == *"201"* ]]; then
    log_print "upload $bundleFile finish"
  else
    echo "uploadBundleToMavenCenter $bundleFile fail, should upload again"
    uploadBundleToMavenCenter
  fi
}

function downloadFile() {
  log_print "start downloadFile..."
  #下载文件
#  curl -L -O -C - $1
  curl -L -O $1
  log_print "downloadFile end"
}

function checkFileLength() {
  if [ -z "$fl" ]; then
    #curl -L -sI $fileUrl | grep -i Content-Length | awk '$2>0 {print $2}' > $fileInfoName
    curl -L -I $fileUrl | grep -i Content-Length | awk '$2>0 {print $2}' > $fileInfoName
    fl=$(cat $fileInfoName)
    echo "file content length: $fl"
    #再次检查是否获取到文件大小
    checkFileLength
  fi
}

function checkFile() {
  echo "check file: $filename"
  if [[ -e $file ]];then
    echo "current file exist: $filename"
    #需要校验文件大小是否与返回的文件大小一致
    fileInfoName=./fileinfo/${filename}.txt
    fl=$(cat $fileInfoName)
    echo "file content length: $fl"
    #如果文件长度小于等于0，则从新获取文件大小
    checkFileLength
    #获取文件大小
    downFileLength=`du -b $filename | awk '{print $1}'`
    echo "have downloaded file length: $downFileLength"
    if [ $downFileLength -lt $fl ]; then
        #重新下载
        downloadFile $fileUrl
        #再次进行检查
        checkFile
    fi
  else
    downloadFile $fileUrl
    #再次进行检查
    checkFile
  fi
}

function downloadFiles() {
  makeDir fileinfo
  for type in ${file_type_arry[@]}
  do
    filename="${versionName}${type}"
    fileUrl="${versionUrl}${filename}"
    echo "current filename: $filename fileUrl:$fileUrl"
    file="`pwd`/${filename}"
    echo "current file:$file"
    checkFile
    if [ $type = ".pom" ]; then
      replaceInfoToMavenCenter
    fi
    gpgFiles $filename
#    if [ $type = ".pom" ]; then
#      uploadSingleFileToMavenCenter
#    fi

  done
  generateBundleFile
  uploadBundleToMavenCenter
}

function downloadSDK() {
  cd av

  for version in ${sdk_version_array[@]}
  do
    echo "current item: $version"
    versionUrl="${artifactUrl}${version}/"
    versionName="${projectName}-${version}"
    if [[ ! -d $version ]];then
      mkdir $version
    fi
    cd $version
    echo "current path: `pwd`"
    downloadFiles
    cd ..
  done
  cd ..
}

function downloadLiteSDK() {
  cd lite

  for version in ${sdk_lite_version_array[@]}
  do
    echo "current item: $version"
    versionUrl="${artifactUrl}${version}/"
    versionName="${projectName}-${version}"
    if [[ ! -d $version ]];then
      mkdir $version
    fi
    cd $version
    echo "current path: `pwd`"
    downloadFiles
    cd ..
  done
  cd ..
}

function downloadTaibao() {
  cd taibao
  for version in ${sdk_taibao_version_array[@]}
  do
    echo "current item2: $version"
    versionUrl="${artifactUrl}${version}/"
    versionName="${projectName}-${version}"
    if [[ ! -d $version ]];then
      mkdir $version
    fi
    cd $version
    echo "current path: `pwd`"
    downloadFiles
    cd ..
  done
  cd ..
}

function downloadAgent() {
  cd agent
  for version in ${agentsdk_version_array[@]}
  do
    echo "current item2: $version"
    versionUrl="${artifactUrl}${version}/"
    versionName="${projectName}-${version}"
    if [[ ! -d $version ]];then
      mkdir $version
    fi
    cd $version
    echo "current path: `pwd`"
    downloadFiles
    cd ..
  done
  cd ..
}

function downloadJcenterLibrary() {
  cd $OUTDIR
  echo "current path: `pwd`"
  for project in ${project_name_arry[@]}
  do
    artifactUrl="${baseUrl}${project}/"
    projectName="${project}"
    if [[ $project = "kefu-sdk" ]];then
      downloadSDK
    elif [[ $project = "kefu-sdk-lite" ]];then
      downloadLiteSDK
    elif [[ $project = "kefu-sdk-taibao" ]];then
      downloadTaibao
    elif [[ $project = "kefu-agentsdk-android" ]];then
      downloadAgent
    fi
  done
  cd ..
}

downloadJcenterLibrary
#test