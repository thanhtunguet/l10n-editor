import {Provider} from 'react-redux';
import {persistor, store} from '../../store/store';
import React from 'react';
import FigmaConfigScreen from 'src/modules/figma/FigmaConfigScreen';
import {PersistGate} from 'redux-persist/integration/react';

function PopupApp() {
  return (
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <FigmaConfigScreen />
      </PersistGate>
    </Provider>
  );
}

export default PopupApp;
