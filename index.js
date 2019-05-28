
import { NativeModules } from 'react-native';

const { RNAmapNavigate } = NativeModules;

export default {

/**
     * 打开导航参数
     * @param options 出发点、目的地
     * @param callback
     */
showNavigation(addressList, callback) {
      
        RNAmapNavigate.showNavigation(addressList, callback)
    },

};
