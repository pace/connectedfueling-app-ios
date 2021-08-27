DEPLOYMENT_TARGET_VALID=`expr ${IPHONEOS_DEPLOYMENT_TARGET} \< "11.0"`;
if [ $DEPLOYMENT_TARGET_VALID = 1 ]; then
   echo "Error: swiftGen color generation from Asset catalog is not supported before iOS 11.0! Please adjust swiftGen template or deployment target"
   exit 1
fi

