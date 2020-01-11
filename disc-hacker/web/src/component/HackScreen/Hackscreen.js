import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import Button from '@material-ui/core/Button';
import React, { useEffect, useState } from 'react';
import { makeStyles } from '@material-ui/core';
import Nui from '../../util/Nui';
import { connect, useSelector } from 'react-redux';
import Grid from '@material-ui/core/Grid';
import * as math from 'lodash';

const useStyles = makeStyles(theme => ({
  paper: {
    width: '100%',
    height: '100%',
    padding: theme.spacing(2),
  },
  textfield: {
    position: 'absolute',
    bottom: 0,
    left: theme.spacing(2),
    width: '100%'
  },
  cssOutlinedInput: {
    '&$cssFocused $notchedOutline': {
      borderColor: 'green !important'
    },
    color:'#00FF00',
  },
  notchedOutline: {
    borderWidth: '1px',
    borderColor: 'green !important'
  },
  grid: {
    maxHeight: '80%',
    overflowY: 'auto',
    overflowX: 'hidden',
  },
}));
export default connect()((props) => {
  const classes = useStyles();
  const lines = useSelector(state => state.hack.lines);
  const generatorType = useSelector(state => state.hack.generatorType);
  const hackToolApp = useSelector(state => state.hack.hackToolApp);
  const [text, setText] = useState('');

  const exit = () => {
    Nui.send('Close');
    props.dispatch({
      type: 'APP_HIDE',
    });
    setText('');
  };

  const clear = () => {
    props.dispatch({
      type: 'CLEAR_LINES',
    });
    setText('');
  };

  const sendCommand = (text, hackToolApp) => {
    Nui.send('Command', {
      code: text,
      app: hackToolApp,
    });
    props.dispatch({
      type: 'ADD_LINE',
      payload: {
        line: text
      },
    });
    setText('');
  };

  const sendAppChange = (app) => {
    Nui.send("ChangeApp", {
      app: app
    });
    setText("");
  };

  const handleEnter = (event) => {
    if (event.keyCode === 13) {
      switch (text) {
        case 'cls': {
          clear();
          break;
        }
        case 'exit': {
          exit();
          break;
        }
        default: {
          if (text.startsWith('./')){
            sendAppChange(text.substr(2))
          } else {
            sendCommand(text, hackToolApp);
          }
        }
      }
    }
  };

  useEffect(() => {
    const int = setInterval(() => {
      const element = document.getElementById('grid');
      element.scrollTop = element.scrollHeight;
    }, 100);
    return () => clearInterval(int)
  }, []);

  useEffect(() => {
    if (generatorType !== null) {
      const int = setInterval(() => {
          if (generatorType === 'bruteforce') {
            props.dispatch({
              type: 'ADD_LINE',
              payload: {
                line: 'Scanning for ' + math.random(10000)
              },
            });
          }
          if (generatorType == null) {
            clearInterval(int);
          }
        }
        , 250);
      return () => clearInterval(int);
    }
  }, [generatorType]);


  return <Paper className={classes.paper}>
    <Grid container className={classes.grid} id={'grid'}>
      {lines.map(
        value =>
          <Grid item xs={12}>
            <Typography variant={'body2'}>{value}</Typography>
          </Grid>,
      )}
    </Grid>
    <TextField onKeyDown={handleEnter} variant={'outlined'} className={classes.textfield} value={text}
               InputProps={{
      classes: {
        root: classes.cssOutlinedInput,
        notchedOutline: classes.notchedOutline,
      }
    }}
               onChange={(event) => setText(event.target.value)}/>
  </Paper>;
});
