
# react-native-amap-navigate

## Getting started

`$ npm install react-native-amap-navigate --save`

### Mostly automatic installation

`$ react-native link react-native-amap-navigate`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-amap-navigate` and add `RNAmapNavigate.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNAmapNavigate.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.amap.navigate.RNAmapNavigatePackage;` to the imports at the top of the file
  - Add `new RNAmapNavigatePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-amap-navigate'
  	project(':react-native-amap-navigate').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-amap-navigate/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-amap-navigate')
  	```


## Usage
```javascript
import RNAmapNavigate from 'react-native-amap-navigate';

// TODO: What to do with the module?
RNAmapNavigate;
```
  