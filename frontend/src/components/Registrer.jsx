import React from "react";
import { Button, Card, Checkbox, Form, Input } from "antd";
import { axiosInstance } from "../auth/AxiosConfig.jsx";
import { toast } from "react-toastify";

const Registrer = () => {
    const onFinish = async (values) => {
        try {
            const response = await axiosInstance.post("/user/register", {
                name: values.name,
                email: values.email,
                password: values.password,
            });
            toast.error(
                "Register success! Please check your email: " +
                    response.data.DATA.EMAIL,
                {
                    position: "top-center",
                }
            );
            window.location.href = "/";
        } catch (error) {
            toast.success(error.response.data.MESSAGE, {
                position: "top-center",
            });
        }
    };
    const onFinishFailed = (errorInfo) => {
        console.log("Failed:", errorInfo);
    };
    return (
        <>
            <div style={styles.container}>
                <Card title="Register" style={styles.card}>
                    <Form
                        name="basic"
                        labelCol={{ span: 8 }}
                        wrapperCol={{ span: 16 }}
                        style={{ maxWidth: 600 }}
                        initialValues={{ remember: false }}
                        onFinish={onFinish}
                        onFinishFailed={onFinishFailed}
                        autoComplete="off"
                    >
                        <Form.Item
                            label="Name"
                            name="name"
                            rules={[
                                {
                                    required: true,
                                    message: "Please input your name!",
                                },
                            ]}
                        >
                            <Input />
                        </Form.Item>

                        <Form.Item
                            label="Email"
                            name="email"
                            rules={[
                                {
                                    required: true,
                                    message: "Please input your email!",
                                },
                            ]}
                        >
                            <Input />
                        </Form.Item>

                        <Form.Item
                            label="Password"
                            name="password"
                            rules={[
                                {
                                    required: true,
                                    message: "Please input your password!",
                                },
                            ]}
                        >
                            <Input.Password />
                        </Form.Item>

                        <Form.Item label={null}>
                            <Button type="primary" htmlType="submit">
                                Submit
                            </Button>
                        </Form.Item>
                    </Form>
                    <Form.Item
                        label="Already have an account?"
                        style={{ textAlign: "right" }}
                    >
                        <a href="/login">Login</a>
                    </Form.Item>
                </Card>
            </div>
        </>
    );
};

const styles = {
    container: {
        minHeight: "100vh",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#f0f2f5",
    },
    card: {
        width: 550,
    },
};

export default Registrer;
