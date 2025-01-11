"use client";

import React, { useLayoutEffect, useRef } from "react";
import NavigationHomeIcon from "./Icons/NavigationHomeIcon";
import NavigationPurchaseIcon from "./Icons/NavigationPurchaseIcon";
import NavigationRentIcon from "./Icons/NavigationRentIcon";
import NavigationAccountIcon from "./Icons/NavigationAccountIcon";
import NavigationSettingsIcon from "./Icons/NavigationSettingsIcon";
import BearLogo from "./svgs/BearLogoSvg";
import Link from "next/link";

const Navbar = () => {
  const refs = useRef<HTMLLIElement[]>([]);
  const indicator = useRef<HTMLDivElement>(null);
  const handleClick = (index: number) => {
    if (!refs.current[index] || !indicator.current) return;
    const elementRect = refs.current[index].getBoundingClientRect();
    const navbarRect = refs.current[0]?.parentElement?.getBoundingClientRect();
    if (navbarRect) {
      const relativeLeft = elementRect.left - navbarRect.left;
      indicator.current.style.transform = `translateX(${relativeLeft - elementRect.width * 0.1}px)     scaleX(${elementRect.width * 1.5}) `;
      indicator.current.style.background = "gray";
      indicator.current.style.display = "block";
    }
  };
  useLayoutEffect(() => {
    handleClick(0);
    if (indicator.current !== null) indicator.current.style.background = "#B1000B";
  }, [])

  return (
    <>
      <nav className="HomePageNavbar w-[60vw] h-[13vh] relative">
        <div
          ref={indicator}
          onTransitionEnd={() => {
            if (indicator.current) {
              indicator.current.style.background = "#B1000B";
            }
          }}
          style={{
            left: 0,
            borderRadius: 0.20,
            background: "gray",
            transition: "0.5s all ease",
            zIndex: 0,
            height: "13vh",
            display: "none",
            transformOrigin: "top left",
            width: 1,
            position: "absolute",
          }}
        ></div>
        <ul
          style={{ zIndex: 2, position: "relative" }}
          className="flex align-center justify-around h-[100%] w-[100%] pr-[5%] pl-[5%]"
        >
          <li
            ref={(el) => (refs.current[0] = el!)}
            onClick={() => handleClick(0)}
          >
            <Link href={"/"}>
              <NavigationHomeIcon />
            </Link>
          </li>
          <li
            ref={(el) => (refs.current[1] = el!)}
            onClick={() => handleClick(1)}
          >
            <Link href={"/purchase"}>
              <NavigationPurchaseIcon />
            </Link>
          </li>
          <li
            ref={(el) => (refs.current[2] = el!)}
            onClick={() => handleClick(2)}
          >
            <Link href={"/rental"}>
              <NavigationRentIcon />
            </Link>
          </li>
          <li className="brandname">
            BARLIH
            <BearLogo />
          </li>
          <li ref={(el) => (refs.current[3] = el!)}
            onClick={() => handleClick(3)}>
            <NavigationAccountIcon />
          </li>
          <li ref={(el) => (refs.current[4] = el!)}
            onClick={() => handleClick(4)}>
            <NavigationSettingsIcon />
          </li>
        </ul>
      </nav >
    </>
  );
};

export default Navbar;
