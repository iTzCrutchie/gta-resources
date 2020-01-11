import React, { useEffect, useState } from 'react';
import Nui from '../../../util/Nui';
import { makeStyles } from '@material-ui/styles';
import ListItem from '@material-ui/core/ListItem';
import { useSelector } from 'react-redux';
import SearchBar from '../../UI/SearchBar/SearchBar';
import List from '@material-ui/core/List';
import ListItemText from '@material-ui/core/ListItemText';
import ListItemSecondaryAction from '@material-ui/core/ListItemSecondaryAction';
import * as lodash from 'lodash';
import Grid from '@material-ui/core/Grid';
import { Paper } from '@material-ui/core';
import ListSubheader from '@material-ui/core/ListSubheader';
import Tooltip from '@material-ui/core/Tooltip';
import ButtonGroup from '@material-ui/core/ButtonGroup';
import Button from '@material-ui/core/Button';
import AddBoxRoundedIcon from '@material-ui/icons/AddBoxRounded';
import IndeterminateCheckBoxRoundedIcon from '@material-ui/icons/IndeterminateCheckBoxRounded';

const useStyles = makeStyles(theme => ({
  list: {
    width: '100%',
    backgroundColor: theme.overrides.MuiPaper.root.backgroundColor,
    position: 'relative',
    overflow: 'auto',
    maxHeight: '20vh',
    minHeight: '20vh',
  },
  root: {
    width: '100%',
  },
  paper: {
    padding: theme.spacing(1),
    width: '100%',
  },
  listSection: {
    backgroundColor: 'inherit',
  },
  ul: {
    backgroundColor: 'inherit',
    padding: 0,
  },
}));

export default (props) => {
  const classes = useStyles();
  const crimes = useSelector(state => state.crime.crimes);
  const [filteredCrimes, setFilteredCrimes] = useState({});
  const [filter, setFilter] = useState('');
  const [categories, setCategories] = useState('');


  useEffect(() => {
    if (filter !== '') {
      setFilteredCrimes(crimes.filter(crime => crime.name.toLowerCase().includes(filter.toLowerCase())));
    } else setFilteredCrimes(crimes);
  }, [filter, crimes]);

  useEffect(() => {
    setCategories(lodash.keysIn(lodash.groupBy(filteredCrimes, (crime) => crime.type)));
  }, [filteredCrimes]);

  return (
    <Grid className={classes.root} container justify={'center'} alignItems={'center'} spacing={1}>
      <Grid item xs={12}>
        <SearchBar instant search={(search => setFilter(search))}/>
      </Grid>
      <Grid item xs={12}>
        <Paper className={classes.paper}>
          <List className={classes.list} subheader={<li/>}>
            {lodash.map(categories, (cat => {
              return (
                <li className={classes.listSection}>
                  <ul className={classes.ul}>
                    <ListSubheader>{cat}</ListSubheader>
                    {lodash.map(filteredCrimes.filter(crime => crime.type === cat), (crime) =>
                      <Tooltip title={crime.description} placement="right-end">
                        <ListItem dense>
                          <ListItemText primary={crime.name}/>
                          <ListItemSecondaryAction>
                            <ButtonGroup size="small" aria-label="small outlined button group" variant={'text'}>
                              <Button
                                onClick={() => props.removeCrime(crime.id)}><IndeterminateCheckBoxRoundedIcon/></Button>
                              <Button>{props.selectedCrimes.find(value => value.id === crime.id)? props.selectedCrimes.find(value => value.id === crime.id).count : 0}</Button>
                              <Button onClick={() => props.addCrime(crime.id)}><AddBoxRoundedIcon/></Button>
                            </ButtonGroup>
                          </ListItemSecondaryAction>
                        </ListItem>
                      </Tooltip>)}
                  </ul>
                </li>
              );
            }))}

          </List>
        </Paper>
      </Grid>
    </Grid>
  );
}
