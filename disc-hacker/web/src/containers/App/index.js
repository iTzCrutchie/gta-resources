import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import AppScreen from '../../component/UI/AppScreen/AppScreen';
import Theme from './../../theme/Theme';
import { makeStyles, MuiThemeProvider } from '@material-ui/core';
import Paper from '@material-ui/core/Paper';
import { grey } from '@material-ui/core/colors';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import Button from '@material-ui/core/Button';
import Hackscreen from '../../component/HackScreen/Hackscreen';



const App = ({ hidden }) => {


  return (
    <MuiThemeProvider theme={Theme}>
      <AppScreen hidden={hidden}>
        <Hackscreen />
      </AppScreen>
    </MuiThemeProvider>

  );
};

App.propTypes = {
  hidden: PropTypes.bool.isRequired,
};

const mapStateToProps = state => ({ hidden: state.app.hidden });

export default connect(mapStateToProps)(App);
