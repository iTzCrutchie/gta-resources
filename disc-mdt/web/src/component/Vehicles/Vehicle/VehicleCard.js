import { makeStyles, Paper, TableCell, Typography } from '@material-ui/core';
import React, { useState } from 'react';
import Grid from '@material-ui/core/Grid';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableRow from '@material-ui/core/TableRow';
import Fab from '@material-ui/core/Fab';
import InfoIcon from '@material-ui/icons/Info';
import PhotoCameraIcon from '@material-ui/icons/PhotoCamera';
import Card from '../../UI/Card/Card';
import { red } from '@material-ui/core/colors';
import ExpansionPanel from '@material-ui/core/ExpansionPanel';
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary';
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails';

const useStyles = makeStyles(theme => ({
  table: {
    textAlign: 'left',
    width: '100%',
  },
  tablePaper: {
    marginTop: theme.spacing(3),
    overflowX: 'auto',
    marginBottom: theme.spacing(2),
  },
  infoFab: {
    position: 'absolute',
    margin: theme.spacing(1),
    bottom: theme.spacing(0),
    right: theme.spacing(1),
  },
  pictureFab: {
    position: 'absolute',
    margin: theme.spacing(1),
    top: theme.spacing(0),
    right: theme.spacing(1),
  },
  capitalize: {
    textTransform: 'capitalize',
  },
  alert: {
    backgroundColor: red[500],
    color: red[500].getContrastText,
  },
  activePanel: {
    maxHeight: '30vh',
    overflow: 'auto',
    backgroundColor: red[500],
    color: red[500].getContrastText,
  },
  panel: {
    maxHeight: '30vh',
    overflow: 'auto',
  },
}));

export default function VehicleCard(props) {
  const classes = useStyles();

  const onInfoClick = () => {
    props.setSelectedVehicle(props.data);
    props.setModalState(true);
  };

  const onPhotoClick = () => {
    props.setSelectedVehicle(props.data);
    props.setPhotoModalState(true);
  };

  const alertActive = [props.data.bolo].includes(true);

  const [currentAlert, setCurrentAlert] = useState(null);

  return (
    <Card title={props.data.plate}>
      <Grid container justify={'flex-start'} alignItems={'flex-start'} spacing={3}>
        <Grid item xs={6}>
          <Card title={'Info'} variant={'h6'}>
            <Paper className={classes.tablePaper}>
              <Table className={classes.table} size="small" aria-label="a dense table">
                <TableBody>
                  <TableRow><TableCell>Owner</TableCell><TableCell><Typography variant={'body1'}
                                                                               className={classes.capitalize}>{props.data.firstname + ' ' + props.data.lastname}</Typography></TableCell></TableRow>
                  <TableRow><TableCell>Model</TableCell><TableCell><Typography variant={'body1'}
                                                                               className={classes.capitalize}>{props.data.model.toLowerCase()}</Typography></TableCell></TableRow>
                  <TableRow><TableCell>Primary Color</TableCell><TableCell><Typography variant={'body1'}
                                                                                       className={classes.capitalize}>{props.data.colorPrimary}</Typography></TableCell></TableRow>
                  <TableRow><TableCell>Secondary Color</TableCell><TableCell><Typography variant={'body1'}
                                                                                         className={classes.capitalize}>{props.data.colorSecondary}</Typography></TableCell></TableRow>
                </TableBody>
              </Table>
            </Paper>
          </Card>
        </Grid>
        <Grid item xs={6}>
          {alertActive && <Card title={'Current Active Alerts'} variant={'h6'}>
            <ExpansionPanel expanded={currentAlert === 'bolo'}
                            onChange={(event, expanded) => expanded ? setCurrentAlert('bolo') : setCurrentAlert(0)}>
              <ExpansionPanelSummary className={props.data.bolo ? classes.activePanel : classes.panel}>
                <Typography variant={'body1'}>
                  BOLO
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Table className={classes.table} size="small" aria-label="a dense table">
                  <TableBody>
                    <TableRow><TableCell>State</TableCell><TableCell><Typography variant={'body1'}
                                                                                 className={classes.capitalize}>{props.data.bolo ? 'Active' : 'Inactive'}</Typography></TableCell></TableRow>
                    <TableRow><TableCell>Reason</TableCell><TableCell><Typography variant={'body1'}
                                                                                  className={classes.capitalize}>{props.data.bolo_reason}</Typography></TableCell></TableRow>
                  </TableBody>
                </Table>
              </ExpansionPanelDetails>
            </ExpansionPanel>
          </Card>}
        </Grid>
      </Grid>
      {!props.hideFab && (<Fab aria-label="like" className={classes.infoFab} onClick={onInfoClick}>
        <InfoIcon/>
      </Fab>)}
      {!props.hideFab && <Fab className={classes.pictureFab} onClick={onPhotoClick}>
        <PhotoCameraIcon/>
      </Fab>}
    </Card>
  );

}
