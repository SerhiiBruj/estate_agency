"use client";
import { useState } from "react";

const TwoRadios = ({ setFirst, isFirst, argument1, argument2 }: { setFirst: (value: boolean) => void, isFirst: boolean | null }) => {
    const [value, setValue] = useState<boolean>(false);

    const handleClick = (newValue: boolean) => {
        setFirst(newValue);
        setValue(newValue);
    };

    return (
        <>
            <div className="flex justify-end items-center">
                <h2 className="HomeSearchNameOfOptionIn pr-2 text-xl">{argument1}</h2>
                <div
                    onClick={() => handleClick(true)}
                    style={{
                        background: value === true ? "#96000d" : "#888888",
                        transition: "all ease 0.2s",
                    }}
                    className="h-10 w-10 border-4 bg-[#888888] rounded-[50%] border-red-950 cursor-pointer"
                    aria-pressed={value === false}
                ></div>
            </div>
            <div className="flex justify-start items-center">
                <div
                    onClick={() => handleClick(false)}
                    style={{
                        background: value === true ? "#888888" : "#96000d",
                        transition: "all ease 0.2s",
                    }}
                    className="h-10 w-10 border-4 bg-[#888888] rounded-[50%] border-red-950 cursor-pointer"
                    aria-pressed={value === true}
                ></div>
                <h2 className="HomeSearchNameOfOptionIn pl-2 text-white text-xl">{argument2}</h2>
            </div>
        </>
    );
};

export default TwoRadios;
