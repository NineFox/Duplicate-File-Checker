#!/bin/bash

sourceArray=()
destinationArray=()

#あるフォルダ以下にあるファイルを全て出力する関数
function recurDirectry() {
    local files=$1
    local fileArray=$2
    local directryArray=$3

    for filePath in $files; do
        if [ -f $filePath ]; then
            fileArray+=($filePath)
            echo $filePath
        elif [ -d $filePath ]; then
            recurDirectry "${filePath}/*" "${fileArray}" "${directryArray}"
        fi
    done
}

#md5sum コマンドからファイルパスを削除する
function getMd5SumOnly() {
    local md5sumResult=`md5sum $1`
    echo "${md5sumResult%% *}"
}

#2つの配列から重複している要素だけを取り出す
function duplicateElements() {

    local resultArray=()

    for p in ${sourceArray[@]}; do
        for q in ${destinatinationArray[@]}; do
            #echo "this is q = ${q}"
            #echo "this is p = ${p}"
            if [ `getMd5SumOnly $p` = `getMd5SumOnly $q` ]; then
                resultArray+=($p)
            fi
        done
    done
    echo ${resultArray[@]}
}

#2つの配列から重複していない要素だけを取り出す
function noDuplicateElements() {

    local resultArray=()
    local isContain=0

    for p in ${sourceArray[@]}; do
        isContain=0
        for q in ${destinatinationArray[@]}; do
            if [ `getMd5SumOnly $p` = `getMd5SumOnly $q` ]; then
                isContain=1
                break;
            fi
        done

        if [ "0" -eq "$isContain" ]; then
            resultArray+=($p)
        fi
    done
    echo ${resultArray[@]}
}



#比較元
sourceArray+=(`recurDirectry "${1}*" "" ""`)
#比較先
destinatinationArray+=(`recurDirectry "${2}*" "" ""`)

echo ${sourceArray[@]}

echo -e \

echo ${destinatinationArray[@]}

echo -e \

echo "Duplicate files"
resultDuplicate+=(`duplicateElements`)
for i in ${resultDuplicate[@]}; do
    echo $i
done

echo -e \

echo "No duplicate files"
resultNoDuplicate+=(`noDuplicateElements`)
for i in ${resultNoDuplicate[@]}; do
    echo $i
done
