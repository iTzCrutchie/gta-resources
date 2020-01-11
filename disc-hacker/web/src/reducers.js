import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import hackReducer from 'component/HackScreen/reducer';

export default () =>
  combineReducers({
    app: appReducer,
    hack: hackReducer,
  });
