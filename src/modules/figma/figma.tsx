import React from 'react';
import Modal from 'antd/es/modal';
import FloatButton from 'antd/es/float-button';
import {QuestionCircleOutlined} from '@ant-design/icons';
import {createRoot} from 'react-dom/client';

const App: React.FC = () => {
  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const showModal = () => {
    setIsModalOpen(true);
  };

  const handleOk = () => {
    setIsModalOpen(false);
  };

  const handleCancel = () => {
    setIsModalOpen(false);
  };

  return (
    <>
      <FloatButton
        icon={<QuestionCircleOutlined />}
        type="primary"
        onClick={showModal}
      />
      <Modal
        title="Basic Modal"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}>
        Open figma
      </Modal>
    </>
  );
};

export default App;

const rootDiv = document.createElement('div');
rootDiv.id = 'l10n-root';
const reactRoot = createRoot(rootDiv);
reactRoot.render(<App />);
document.body.appendChild(rootDiv);
