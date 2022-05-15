
# Name of the app to check. Change this to your application name!
APP=nextapp
echo $APP

# Determine version of Nx installed
NX_VERSION=$(node -e "console.log(require('./package.json').devDependencies['@nrwl/workspace'])")
TS_VERSION=$(node -e "console.log(require('./package.json').devDependencies['typescript'])")
echo "LOG: NX_VERSION=$NX_VERSION TS_VERSION=$TS_VERSION"

# Install @nrwl/workspace in order to run the affected command
echo "LOG: installing @nrwl/workspace"
npm install -D @nrwl/workspace@$NX_VERSION --prefer-offline
echo "LOG: done installing @nrwl/workspace"

echo "LOG: installing typescript"
npm install -D typescript@$TS_VERSION --prefer-offline
echo "LOG: done installing typescript"

# Run the affected command, comparing latest commit to the one before that
echo "LOG: running nx affected"
npx nx affected:apps --plain --base HEAD~1 --head HEAD | grep $APP -q
echo "LOG: completed nx affected"

# Store result of the previous command (grep)
IS_AFFECTED=$?

if [ $IS_AFFECTED -eq 1 ]; then
  echo "🛑 - Build cancelled"
  exit 0
elif [ $IS_AFFECTED -eq 0 ]; then
  echo "✅ - Build can proceed"
  exit 1
fi