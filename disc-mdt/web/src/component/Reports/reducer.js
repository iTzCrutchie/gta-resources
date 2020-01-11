import { SET_REPORTS } from './actions';

export const initialState = {
  reports: []
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case SET_REPORTS: {
      return {
        ...state,
        reports: action.payload.reports
      }
    }
    default:
      return state;
  }
};

export default reducer;
