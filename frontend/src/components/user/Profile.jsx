import React, { useEffect } from "react";
import { axiosInstance } from "../../auth/AxiosConfig.jsx";
import { toast } from "react-toastify";
import {
    Breadcrumb,
    Button,
    Card,
    Col,
    Form,
    Input,
    InputNumber,
    Row,
    Space,
} from "antd";
import Navbar from "../Navbar.jsx";
import secureLocalStorage from "react-secure-storage";
import { useNavigate } from "react-router-dom";

const Profile = () => {
    const navigate = useNavigate();
    const [form] = Form.useForm();
    useEffect(() => {
        const user = secureLocalStorage.getItem("user");
        form.setFieldsValue({
            name: user?.NAME || "",
            email: user?.EMAIL || "",
            phone: user?.PHONE || "",
            address: user?.ADDRESS || "",
        });
    }, [form]);
    const onFinish = async (values) => {
        if (
            values.password !== "" &&
            values.password !== values.confirmPassword
        ) {
            toast.error("Password and confirm password is not same", {
                position: "top-center",
            });
            return;
        }
        try {
            const response = await axiosInstance.post("/user/update", {
                name: values.name,
                email: values.email,
                password: values.password,
                phone: values.phone,
                address: values.address,
            });
            if (response.data) {
                toast.success("Update Success !", {
                    position: "top-center",
                });
                navigate("/");
            }
        } catch (error) {
            toast.error(error.response.data.MESSAGE, {
                position: "top-center",
            });
        }
    };
    return (
        <>
            <Row>
                <Col span={12} offset={6}>
                    <Space
                        direction="vertical"
                        size="middle"
                        style={{ display: "flex" }}
                    >
                        <Navbar />
                        <Breadcrumb
                            items={[
                                {
                                    title: "Home",
                                },
                                {
                                    title: "User",
                                },
                                {
                                    title: "Profile",
                                },
                            ]}
                        />
                        <Form
                            form={form}
                            name="basic"
                            labelCol={{ span: 8 }}
                            wrapperCol={{ span: 16 }}
                            style={{ maxWidth: 600 }}
                            onFinish={onFinish}
                            initialValues={{
                                remember: true,
                            }}
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
                            <Form.Item label="Phone" name="phone">
                                <InputNumber style={{ width: "100%" }} />
                            </Form.Item>

                            <Form.Item
                                label="Address"
                                name="address"
                                rules={[
                                    {
                                        required: false,
                                        message: "Please input!",
                                    },
                                ]}
                            >
                                <Input.TextArea />
                            </Form.Item>

                            <Form.Item label="Password" name="password">
                                <Input.Password />
                            </Form.Item>
                            <Form.Item
                                label="Confirm Password"
                                name="confirmPassword"
                            >
                                <Input.Password />
                            </Form.Item>

                            <Form.Item label={null}>
                                <Button type="primary" htmlType="submit">
                                    Submit
                                </Button>
                            </Form.Item>
                        </Form>
                    </Space>
                </Col>
            </Row>
        </>
    );
};

export default Profile;
