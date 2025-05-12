import React, { useEffect, useState } from "react";
import { Menu } from "antd";
import { AppstoreOutlined, UserOutlined } from "@ant-design/icons";
import secureLocalStorage from "react-secure-storage";

const menuItem = (userName) => {
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
            label: `${userName}`,
            key: "setting",
            icon: <UserOutlined />,
            style: { marginLeft: "auto" },
            children: [
                {
                    label: <a href="/profile">Edit Profile</a>,
                    key: "profile:1",
                },
                {
                    label: <a href="/logout">Logout</a>,
                    key: "profile:2",
                },
            ],
        },
    ];

    return items;
};

const Navbar = () => {
    const [current, setCurrent] = useState("mail");
    const [userName, setUserName] = useState("");
    useEffect(() => {
        const user = secureLocalStorage.getItem("user");
        setUserName(user.NAME);
    }, []);
    const onClick = (e) => {
        console.log("click ", e);
        setCurrent(e.key);
    };

    return (
        <Menu
            onClick={onClick}
            selectedKeys={[current]}
            mode="horizontal"
            items={menuItem(userName)}
        />
    );
};

export default Navbar;
