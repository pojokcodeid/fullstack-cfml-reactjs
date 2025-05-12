import React, { useState } from "react";
import { Menu } from "antd";
import {
    AppstoreOutlined,
    MailOutlined,
    SettingOutlined,
} from "@ant-design/icons";

const items = [
    {
        label: "Menu",
        key: "SubMenu",
        icon: <AppstoreOutlined />,
        children: [
            {
                type: "group",
                label: "Item 1",
                children: [
                    { label: "Option 1", key: "setting:1" },
                    { label: "Option 2", key: "setting:2" },
                ],
            },
            {
                type: "group",
                label: "Item 2",
                children: [
                    { label: "Option 3", key: "setting:3" },
                    { label: "Option 4", key: "setting:4" },
                ],
            },
        ],
    },
    {
        label: "Settings",
        key: "setting",
        icon: <SettingOutlined />,
        style: { marginLeft: "auto" },
        children: [
            {
                label: <a href="/edit/profile">Edit Profile</a>,
                key: "profile:1",
            },
            {
                label: <a href="/logout">Logout</a>,
                key: "profile:2",
            },
        ],
    },
];

const Navbar = () => {
    const [current, setCurrent] = useState("mail");
    const onClick = (e) => {
        console.log("click ", e);
        setCurrent(e.key);
    };

    return (
        <Menu
            onClick={onClick}
            selectedKeys={[current]}
            mode="horizontal"
            items={items}
            style={{ width: "100%", maxWidth: 1200 }}
        />
    );
};

export default Navbar;
