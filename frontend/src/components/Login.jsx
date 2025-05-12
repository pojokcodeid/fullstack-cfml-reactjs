import React from "react";
import { Button, Card, Checkbox, Form, Input } from "antd";
import { toast } from "react-toastify";
import { axiosNoAuth } from "../auth/AxiosConfig.jsx";
import secureLocalStorage from "react-secure-storage";

const Login = () => {
    const onFinish = async (values) => {
        try {
            const response = await axiosNoAuth.post("/user/login", {
                email: values.email,
                password: values.password,
            });
            if (response.data) {
                secureLocalStorage.setItem(
                    "acessToken",
                    response.data.ACCESSTOKEN
                );
                secureLocalStorage.setItem(
                    "refreshToken",
                    response.data.REFRESHTOKEN
                );
                secureLocalStorage.setItem("user", response.data.DATA);
                toast.success("Login Berhasil!", {
                    position: "top-center",
                });
                window.location.href = "/";
            }
        } catch (error) {
            toast.error(error.response.data.MESSAGE, {
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
                <Card title="Login" style={styles.card}>
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
                        label="Don't have an account?"
                        style={{ textAlign: "right" }}
                    >
                        <a href="/register">Register</a>
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
        width: 450,
    },
};

export default Login;
