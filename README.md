
# react-native-inmobi

## Getting started

`$ npm install react-native-inmobi --save`

### Mostly automatic installation

`$ react-native link react-native-inmobi`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-inmobi` and add `RNInmobi.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNInmobi.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.smartapp.rninmobi.RNInmobiPackage;` to the imports at the top of the file
  - Add `new RNInmobiPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-inmobi'
  	project(':react-native-inmobi').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-inmobi/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-inmobi')
  	```


## Usage
```javascript
import RNInmobi from 'react-native-inmobi';

// TODO: What to do with the module?
RNInmobi;
```
  