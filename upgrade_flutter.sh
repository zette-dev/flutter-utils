#!/bin/sh
for prod in dart flutter; do
    echo $prod
    $prod pub global list | while read n v; do
        echo $n
        $prod pub global activate $n
    done
done