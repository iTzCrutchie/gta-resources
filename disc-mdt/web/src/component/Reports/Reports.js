import Screen from '../UI/Screen/Screen';
import Grid from '@material-ui/core/Grid';
import TitleBar from '../UI/TitleBar/TitleBar';
import React, { useEffect } from 'react';
import { makeStyles } from '@material-ui/core';
import SearchBar from '../UI/SearchBar/SearchBar';
import { connect, useSelector } from 'react-redux';
import { searchReports } from './actions';
import ReportsDisplay from './Report/ReportsDisplay/ReportsDisplay';

const useStyles = makeStyles(theme => ({
  root: {
    width: '100%',
  },
  grid: {
    width: '90%',
  },
}));

export default connect()((props) => {
  const classes = useStyles();

  const reports = useSelector(state => state.reports.reports);

  const search = (value) => {
    searchReports(value);
  };

  return (
    <Screen>
      <Grid container direction={'column'} alignItems={'center'} spacing={3} justify={'center'}
            className={classes.root}>
        <TitleBar title={'Reports'}/>
        <Grid spacing={3} className={classes.grid}>
          <Grid item xs={12}>
            <SearchBar search={search}/>
          </Grid>
          <Grid item xs={12}>
            <ReportsDisplay reports={reports}/>
          </Grid>
        </Grid>
      </Grid>
    </Screen>
  );
})
