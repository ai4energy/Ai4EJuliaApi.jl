#!/bin/bash

START=1
END=$1
echo "starting $1 Ai4Energy Julia API servers ..."

for (( c=$START; c<=$END; c++ ))
do
	julia --project=/opt/Ai4EJuliaAPI srv/ai4ejuliaapi.jl &
done

wait
echo "Ai4Energy Julia API servers stopped"