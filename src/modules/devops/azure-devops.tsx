import React from 'react';
import Modal from 'antd/es/modal';
import FloatButton from 'antd/es/float-button';
import {QuestionCircleOutlined} from '@ant-design/icons';
import {createRoot} from 'react-dom/client';
import {Col, Row} from 'antd/es/grid';
import Form from 'antd/es/form';
import Select from 'antd/es/select';
import type DevopsProject from 'src/models/DevopsProject';
import type {DevopsRepository} from 'src/models/DevopsRepository';
import {azureDevopsRepository} from 'src/repositories/azure-devops-repository';

const App: React.FC = () => {
  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const showModal = () => {
    setIsModalOpen(true);
  };

  const handleOk = () => {
    setIsModalOpen(false);
    window.open(chrome.extension.getURL('src/modules/options/options.html'));
  };

  const handleCancel = () => {
    setIsModalOpen(false);
  };

  const [projects, setProjects] = React.useState<DevopsProject[]>([]);

  const [selectedProject, setSelectedProject] = React.useState<string | null>(
    null,
  );

  const [repositories, setRepositories] = React.useState<DevopsRepository[]>(
    [],
  );

  const [selectedRepository, setSelectedRepository] = React.useState<
    string | null
  >(null);

  React.useEffect(() => {
    if (selectedProject) {
      azureDevopsRepository.repositories(selectedProject).subscribe({
        next: (listRepositories) => {
          setRepositories(listRepositories);
        },
      });
    }
  }, [selectedProject]);

  React.useEffect(() => {
    azureDevopsRepository.projects().subscribe({
      next: (listProjects) => {
        setProjects(listProjects);
      },
      error: () => {
        //
      },
    });
  }, []);

  return (
    <>
      <FloatButton
        icon={<QuestionCircleOutlined />}
        type="primary"
        className="m-4"
        onClick={showModal}
      />
      <Modal
        title="Basic Modal"
        open={isModalOpen}
        width={1280}
        okButtonProps={{
          disabled: !selectedProject || !selectedRepository,
        }}
        onOk={handleOk}
        onCancel={handleCancel}>
        <Row gutter={12}>
          <Col span={12} className="gutter-row">
            <Form.Item label="Project">
              <Select
                placeholder="Select a project"
                value={selectedProject}
                className="w-100"
                onChange={(project) => {
                  setSelectedProject(project);
                }}
                options={projects.map((project) => ({
                  value: project.id,
                  label: project.name,
                }))}
              />
            </Form.Item>
          </Col>
          <Col span={12} className="gutter-row">
            <Form.Item label="Repository">
              <Select
                disabled={!selectedProject}
                placeholder="Select a repository"
                value={selectedRepository}
                className="w-100"
                onChange={(repository) => {
                  setSelectedRepository(repository);
                }}
                options={repositories.map((repository) => ({
                  value: repository.id,
                  label: repository.name,
                }))}
              />
            </Form.Item>
          </Col>
        </Row>
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
