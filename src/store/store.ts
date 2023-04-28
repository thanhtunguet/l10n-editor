import {combineReducers, configureStore} from '@reduxjs/toolkit';
import {projectConfigSlice} from './slices/project-config-slice';
import {persistReducer, persistStore} from 'redux-persist';
import type {PersistConfig} from 'redux-persist/es/types';
import storage from 'redux-persist/lib/storage'; // defaults to localStorage for web

const persistConfig: PersistConfig<any> = {
  key: 'root',
  storage,
};

export const store = configureStore({
  reducer: persistReducer(
    persistConfig,
    combineReducers({
      [projectConfigSlice.name]: projectConfigSlice.reducer,
    }),
  ),
});

export const persistor = persistStore(store);
