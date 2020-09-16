#!/bin/bash

for i in {1..5000}
do
	uuidgen >> /root/ccr-data/macuuids
	uuidgen >> /root/ccr-data/winuuids
done