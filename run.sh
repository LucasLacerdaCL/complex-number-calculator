set -e

echo "Getting packages"
{
    dependencies=("complex-number;https://github.com/LucasLacerdaCL/complex-number.git")

    for dependencie in "${dependencies[@]}"
        do
            arrDependencie=(${dependencie//;/ })
            dependencieURL=(${arrDependencie[1]})
            dependencieName=(${arrDependencie[0]})

            echo "${dependencieName}"

            git clone "${dependencieURL}"
            rm -rf ./packages
            mkdir packages
            mv ./"${dependencieName}" ./packages/"${dependencieName}"

            cd ./packages/"${dependencieName}"
            ./run.sh
            if [ -f "../../run.sh" ] && [ -f "./packages" ]
            then
                mv ./packages/* ../../packages
                rm -rf ./packages
            fi
            cd ../../
    done
} &> /dev/null


echo -e "\nClean Dist folder"
{
    rm -rf ./src/dist
    mkdir ./src/dist
} &> /dev/null

echo -e "\nGenerating calculator binary"
{
    g++ -c ./src/implementations/calculator.cpp
    rm -rf ./src/dist/calculator.o
    mv ./calculator.o ./src/dist/
} &> /dev/null

echo -e "\nGenerating main binary"
{
    g++ -c ./src/main.cpp
    rm -rf ./src/dist/main.o
    mv ./main.o ./src/dist/
} &> /dev/null