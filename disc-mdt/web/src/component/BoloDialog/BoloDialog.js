import { Dialog, makeStyles } from '@material-ui/core';
import React, { useState } from 'react';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';

const useStyles = makeStyles(theme => ({
    textfield : {
      width: "100%",
    }
  }
));

export default (props) => {
  const classes = useStyles();
  const handleCancel = () => {
    props.setModalState(false);
  };

  const handleIssue = () => {
    props.setModalState(false);
    props.issue(reason);
  };

  const [reason, setReason] = useState('');

  return (
    <Dialog open={props.open} onClose={props.setModalState} maxWidth={'sm'} fullWidth>
      <DialogContent>
        <DialogContentText>
          {props.active ? 'Remove BOLO for ' + props.identifier : 'Issue BOLO for' + props.identifier}
        </DialogContentText>
        {!props.active && <TextField className={classes.textfield} variant={'outlined'} label={'Reason'} value={reason} multiline rows="2" rowsMax={"2"}
                   onChange={event => setReason(event.target.value)}/>}
      </DialogContent>
      <DialogActions>
        <Button onClick={handleCancel} color="primary">
          Cancel
        </Button>
        <Button onClick={() => handleIssue(reason)} color="primary">
          {props.active ? 'Remove' : 'Issue'}
        </Button>
      </DialogActions>
    </Dialog>);
}
