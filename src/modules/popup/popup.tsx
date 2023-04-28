import {createRoot} from 'react-dom/client';
import React from 'react';
import PopupApp from 'src/modules/popup/PopupApp';

const root = createRoot(document.getElementById('root') as HTMLDivElement);
root.render(<PopupApp />);
