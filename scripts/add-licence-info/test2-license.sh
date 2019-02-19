#Datazoom, Inc ("COMPANY") CONFIDENTIAL
#Copyright (c) 2017-2018 [Datazoom, Inc.], All Rights Reserved. This file is subject to the terms and conditions defined in file 'LICENSE.txt', which is part of this source code package.

#!/bin/bash




sed -i '1s/^/#Datazoom, Inc ("COMPANY") CONFIDENTIAL\n/'  test.yaml

sed -i '2s/^/#Copyright (c) 2017-2018 [Datazoom, Inc.], All Rights Reserved. This file is subject to the terms and conditions defined in file "LICENSE.txt", which is part of this source code package.\n/'  test.yaml

sed -i '3s/^/\n/'  test.yaml