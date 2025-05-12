import React from "react";
import Navbar from "./Navbar.jsx";
import { Col, Row } from "antd";

const Home = () => {
    return (
        <>
            <Row>
                <Col span={12} offset={6}>
                    <Navbar />
                    <h1>Home</h1>
                </Col>
            </Row>
        </>
    );
};

export default Home;
