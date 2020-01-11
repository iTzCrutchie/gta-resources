import { createMuiTheme } from '@material-ui/core';
import { blue, common, grey, lightGreen, red } from '@material-ui/core/colors';

const theme = createMuiTheme(
  {
    typography: {
      allVariants: {
        color:'#00FF00'
      }
    },
    overrides: {
      MuiPaper: {
        elevation1: {
          backgroundColor: '#121212',
          background: '#121212',
          color:'#00FF00'
        }
      },
      MuiInput: {
        root: {
          border: "none",
          color:'#00FF00'
        },
        focused: {
          border: "none",
        }
      }
    }
  }
);

export default theme;
