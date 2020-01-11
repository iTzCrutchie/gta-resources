import lodash from 'lodash';

export const initialState = {
  lines: [],
  generatorType: null,
  hackToolApp: 'root',
};

const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'ADD_LINE':
      const newlines = [...state.lines, state.hackToolApp + '> ' + action.payload.line];
      return {
        ...state,
        lines: lodash.takeRight(newlines, 128),
      };
    case 'CLEAR_LINES': {
      return {
        ...state,
        lines: [],
      };
    }
    case 'START_HACK': {
      return {
        ...state,
        generatorType: action.payload.hackType,
      };
    }
    case 'SWITCH_APP' : {
      const newlines = [...state.lines, state.hackToolApp + '> ' +action.payload.message ];
      return {
        ...state,
        hackToolApp: action.payload.app,
        lines: newlines,
      };
    }
    case 'SUCCESS' : {
      const newlines = [...state.lines, state.hackToolApp + '> Scanning for ' + action.payload.code, state.hackToolApp + '> Found Target At: ' + action.payload.code];
      return {
        ...state,
        code: action.payload.code,
        lines: lodash.takeRight(newlines, 128),
        generatorType: null,
      };
    }
    case 'FAILURE': {
      const newlines = [...state.lines, state.hackToolApp + '> Scanning Failed!'];
      return {
        ...state,
        lines: lodash.takeRight(newlines, 128),
        generatorType: null,
      };
    }
    default:
      return state;
  }
};

export default appReducer;
