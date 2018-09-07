set -e

echo "Getting packages"
{
    dependencies=("complex-number;https://github.com/LucasLacerdaCL/complex-number.git")

    rm -rf ./packages
    mkdir packages

    for dependencie in "${dependencies[@]}"
        do
            arrDependencie=(${dependencie//;/ })
            dependencieURL=(${arrDependencie[1]})
            dependencieName=(${arrDependencie[0]})

            git clone "${dependencieURL}"
            mv ./"${dependencieName}" ./packages/"${dependencieName}"

            cd ./packages/"${dependencieName}"
            ./run.sh
            if [ -f "../../run.sh" ] && [ -d "./packages" ]
            then
                cp -r -f ./packages/* ../../packages
            fi
            cd ../../
    done
} &> /dev/null

if [ ! -d "./src/dist" ]
then
    mkdir ./src/dist
fi

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