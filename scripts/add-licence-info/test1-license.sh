#!/bin/bash

line1="#Datazoom, Inc ("COMPANY") CONFIDENTIAL"
line2="#Copyright (c) 2017-2018 [Datazoom, Inc.], All Rights Reserved. This file is subject to the terms and conditions defined in file 'LICENSE.txt', which is part of this source code package."


echo $line1
echo $line2


sed -i '$line1' test.yaml

#sed -i '1s/^/$line1\n/$line2\n/' test.yaml