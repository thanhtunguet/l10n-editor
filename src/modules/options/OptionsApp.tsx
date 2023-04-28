import {Provider} from 'react-redux';
import {persistor, store} from '../../store/store';
import React from 'react';
import {PersistGate} from 'redux-persist/integration/react';

function OptionsApp() {
  return (
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor} />
    </Provider>
  );
}

export default OptionsApp;
