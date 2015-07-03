#!/bin/bash

#
# This script will checkout SusyNtuple as well as the necessary 
# packages/dependencies to run over SusyNt's tag n0206pup
#
# Note: This checks out packages from SVN, so you may be asked 
# to provide your CERN password. Doing "kinit" before running
# this script is helpful.
#
# daniel.joseph.antrim@cern.ch
# July 3 2015
#

SVNOFF="svn+ssh://svn.cern.ch/reps/atlasoff/"
SVNPHYS="svn+ssh://svn.cern.ch/reps/atlasphys/"

echo "Setting up area for SusyNtuple"
date
echo ""
echo "Cloning SusyNtuple from https://github.com/susynt/SusyNtuple"
git clone https://github.com/susynt/SusyNtuple.git
cd SusyNtuple
echo "Checking out the tag SusyNtuple-00-02-04"
git checkout SusyNtuple-00-02-04
cd ..

# tags to checkout
susyURL="$SVNOFF/PhysicsAnalysis/SUSYPhys/SUSYTools/tags/SUSYTools-00-06-10"
mt2URL="$SVNPHYS/Physics/SUSY/Analyses/WeakProduction/Mt2/tags/Mt2-00-00-01"
trigURL="$SVNPHYS/Physics/SUSY/Analyses/WeakProduction/DGTriggerReweight/tags/DGTriggerReweight-00-00-29"
jvfURL="$SVNOFF/Reconstruction/Jet/JetAnalysisTools/JVFUncertaintyTool/tags/JVFUncertaintyTool-00-00-04"
metURL="$SVNOFF/Reconstruction/MET/METUtilities/tags/METUtilities-00-01-40"

echo "Checking out SusyNtuple dependencies"
svn co $mt2URL Mt2 || return || exit
svn co $trigURL DGTriggerReweight || return || exit
svn co $jvfURL JVFUncertaintyTool || return || exit
svn co $metURL METUtilities || return || exit

# Only need minimal SUSYTools
mkdir -p SUSYTools/SUSYTools SUSYTools/Root SUSYTools/cmt SUSYTools/data
svn export $susyURL/SUSYTools/SUSYCrossSection.h SUSYTools/SUSYTools/SUSYCrossSection.h
svn export $susyURL/Root/SUSYCrossSection.cxx SUSYTools/Root/SUSYCrossSection.cxx
svn export $susyURL/cmt/Makefile.RootCore SUSYTools/cmt/Makefile.RootCore
svn co $susyURL/data SUSYTools/data || return || exit

echo ""
echo "Finished."
date