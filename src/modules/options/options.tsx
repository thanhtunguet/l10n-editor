import {createRoot} from 'react-dom/client';
import React from 'react';
import OptionsApp from 'src/modules/options/OptionsApp';

const root = createRoot(document.getElementById('root') as HTMLDivElement);
root.render(<OptionsApp />);
