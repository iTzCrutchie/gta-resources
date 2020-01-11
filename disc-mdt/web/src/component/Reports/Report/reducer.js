import { SET_JAIL_REPORT } from './actions';

export const initialState = {
  jailReport: {
    arrestingOfficer: '',
    identifier: '',
  },
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case SET_JAIL_REPORT:
      return {
        ...state,
        jailReport: action.payload.jailReport,
      };
    default:
      return state;
  }
};

export default reducer;
