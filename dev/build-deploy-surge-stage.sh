#!/bin/bash

hugo -v -b https://staging.iflowfor8hours.info -d staging -D 
surge staging --domain https://staging.iflowfor8hours.info
