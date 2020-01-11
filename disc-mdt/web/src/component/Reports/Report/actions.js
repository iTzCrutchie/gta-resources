import Nui from '../../../util/Nui';
import { searchCivilians } from '../../Civilians/actions';

export const SET_JAIL_REPORT = 'SET_JAIL_REPORT';

export const postReport = (form, location, date, time, crimes, notes, search) => {
  return dispatch => {
    Nui.send('PostReport', {
      form: form,
      location: location,
      date: date,
      time: time,
      crimes: crimes,
      notes: notes,
    }).then(_ => {
      dispatch(searchCivilians(search));
    });
  };
};
