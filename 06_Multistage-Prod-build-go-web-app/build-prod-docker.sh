#!/bin/sh
echo
echo "   docker build the Builder Image First ....."
echo
# ~ Initial Command with Target Stop set at 'builder'
#docker build --target builder -t builder -f builder.Dockerfile .
# ~ Direct Command without any Target since the File only has one
#docker build -t builder -f builder.Dockerfile .
# ~ Final Section command in the Combo File to stop after 'builder' Target
# ~   Also note the additional Tag assigned to the Builder
docker build --target builder -t gobuilder -f combo.Dockerfile .
echo
echo "   docker build the Production Image Using the Content of Builder Image"
echo
# ~ Initial Command with no target since only one exists
#docker build -t go-docker-prod -f production.Dockerfile .
# ~ Final Section command in the Combo File to stop after 'Production' Target
# ~  Also note that the 'builder' stage will not be executed since its done earlier
docker build --target production -t go-docker-prod -f combo.Dockerfile .
echo
echo "  Here are the Built Images....."
echo
docker images
echo
echo "  Removing the Builder Image....."
echo
docker rmi gobuilder
echo
echo "  Remaining Images....."
echo
docker images
echo
echo "  Done !"
echo