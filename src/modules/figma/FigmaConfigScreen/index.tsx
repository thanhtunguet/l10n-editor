import React from 'react';
import Button from 'antd/es/button';
import Form from 'antd/es/form';
import Input from 'antd/es/input';
import Spin from 'antd/es/spin';
import {useForm} from 'antd/es/form/Form';

interface FigmaConfig {
  apiKey?: string;
}

const FigmaConfigScreen = () => {
  const [loading, setLoading] = React.useState<boolean>(false);

  const onFinish = React.useCallback(async (values: FigmaConfig) => {
    setLoading(true);
    await chrome.storage.sync.set(values).finally(() => {
      setLoading(false);
    });
  }, []);

  const [form] = useForm<FigmaConfig>();

  React.useEffect(() => {
    setLoading(true);
    chrome.storage.sync
      .get()
      .then(({apiKey: figmaApiKey}) => {
        form.setFieldValue('apiKey', figmaApiKey);
      })
      .finally(() => {
        setLoading(false);
      });
  }, [form]);

  return (
    <Spin spinning={loading} tip="Loading Figma config">
      <Form onFinish={onFinish} className="p-4" form={form}>
        <Form.Item
          label="Figma API Key"
          name="apiKey"
          rules={[
            {required: true, message: 'Please enter your Figma API key!'},
          ]}>
          <Input placeholder="Enter your Figma API key" />
        </Form.Item>

        <Form.Item>
          <Button type="primary" htmlType="submit">
            Submit
          </Button>
        </Form.Item>
      </Form>
    </Spin>
  );
};

export default FigmaConfigScreen;
