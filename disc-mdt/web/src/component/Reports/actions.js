import Nui from '../../util/Nui';

export const SET_REPORTS = 'SET_REPORTS';

export const searchReports = (value) => {
  Nui.send('SearchReports', {
    search: value,
  });
};
