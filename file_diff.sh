#!/bin/sh

#あるフォルダ以下にあるファイルを全て出力する関数
function recurDirectry() {
    local files=$1
    local fileArray=$2
    local directryArray=$3

    for filePath in $files; do
        if [ -f $filePath ]; then
            fileArray+=("$filePath")
            echo $filePath
        elif [ -d $filePath ]; then
            recurDirectry "${filePath}/*" "${fileArray}" "${directryArray}"
        fi
    done
}

#2つの配列から重複している要素だけを取り出す
function duplicateElements() {
    local sourceArray=$1
    local destinationArray=$2
    local resultArray=()

    for p in $sourceArray; do
        for q in $destinatinationArray; do
            if [ md5sum $p = md5sum $q ]; then
                resultArray+=$p
            fi
        done
    done
    echo $resultArray
}

#2つの配列から重複していない要素だけを取り出す
function noDuplicateElements() {
    local sourceArray=$1
    local destinationArray=$2
    local resultArray=()
    local isContain=0

    for p in $sourceArray; do
        isContain=0
        for q in $destinatinationArray; do
            if [ md5sum $p -eq md5sum $q ]; then
                isContain=1
                break;
            fi
        done
        if [ 0 -eq $isContain ]; then
            resultArray+=$p
        fi
    done
    echo $resultArray
}


#recurDirectry "${1}*" "" "" 0
#比較元
comparisonSource=`recurDirectry "${1}*" "" ""`
#比較先
comparisonDestination=`recurDirectry "${2}*" "" ""`


echo "重複しているファイル"
echo `duplicateElements $comparisonSource $comparisonDestination`

echo "重複していないファイル"
echo `noDuplicateElements $comparisonSource $comparisonDestination`
