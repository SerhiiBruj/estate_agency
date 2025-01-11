"use client";
import { Box, Button, TextField, } from '@mui/material';
import React, { FormEvent, useRef, useState, } from 'react'
import { CustomAutocomplete, CustomTextFieldWithoutAutocomplete, } from "./CustomMUIComponents"
import TwoRadios from "./TwoRadios"
import styled from 'styled-components';

const cities = [
    "Львів",
    "Івано-Франківськ",
    "Ужгород",
    "Біла Церква",
    "Бурштин",
    "Сколе"
];

function filternums(str: string) {
    return str.replace(/\D/g, "")
}
const CustomTextField = styled(TextField)({
    '& .MuiInputLabel-root': {
        color: '#B1000B',
    },
    '& .MuiInputLabel-root.Mui-focused': {
        color: '#B1000B',
        fontSize: "1.2em"
    },
});

const SearchForm = () => {
    const [city, setCity] = useState<string>("");
    const [type, setType] = useState<string>("");
    const [numOfRooms, setNumOfRooms] = useState<string>("");
    const [areaaOfRealty, setAreaaOfRealty] = useState<string>("");
    const [from, setFrom] = useState<number>(1);
    const [to, setTo] = useState<number>(1);
    const [isResidential, setResidential] = useState<boolean>(true);
    const [isRental, setisRental] = useState<boolean>(true);




    const findRealty = (e: FormEvent) => {
        e.preventDefault();

        alert(`Місто: ${city}, Тип: ${type}, Кількість кімнат: ${numOfRooms}, Площа: ${areaaOfRealty}, Від: ${from}, До: ${to}, Житлова: ${isResidential} Пропозиція:${isRental ? "Оренда" : "Придбання"}`);
    };

    return (
        <form
            action="submit"
            onSubmit={findRealty}
            className="HomeSearchForRealtyForm gap-[30px] p-[5vw] grid grid-cols-2 grid-rows-4"
        >
            <CustomAutocomplete
                disablePortal
                options={cities}
                disableClearable
                value={city}
                onChange={(event, newValue: string) => {
                    setCity(newValue);
                }}
                onInputChange={(event, newInputValue) => {
                    setCity(newInputValue);
                }}
                renderOption={(props, option, index) => {
                    const { key, ...restProps } = props;
                    return (
                        <Box
                            key={key}
                            {...restProps}
                            component="li"
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                padding: '8px 16px',
                                backgroundColor: '#f9f9f9',
                                '&:hover': {
                                    backgroundColor: '#810008 !important',
                                    cursor: 'pointer',
                                    color: 'white',
                                },
                            }}
                        >
                            {option}
                        </Box>
                    )
                }}
                renderInput={(params) => <CustomTextField {...params} label="Місто" />}
            />

            <CustomAutocomplete
                disablePortal
                options={["Апартаменти", "Приватні будинки", "Земельні ділянки"]}
                disableClearable
                value={type}
                onChange={(event, newValue: string) => {
                    setType(newValue);
                }}
                onInputChange={(event, newInputValue) => {
                    setType(newInputValue);
                }}
                renderOption={(props, option, index) => {
                    const { key, ...restProps } = props;
                    return (
                        <Box
                            key={key}
                            {...restProps}
                            component="li"
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                padding: '8px 16px',
                                backgroundColor: '#f9f9f9',
                                '&:hover': {
                                    backgroundColor: '#810008 !important',
                                    cursor: 'pointer',
                                    color: 'white',
                                },
                            }}
                        >
                            {option}
                        </Box>
                    )
                }}
                renderInput={(params) => <CustomTextField {...params} label="Тип" />}
            />

            <TwoRadios setFirst={setResidential} argument1={"Житлова"} argument2={"Комерційна"} />

            <CustomAutocomplete
                disablePortal
                options={["будь-яка", "1-кімнатна", "2-кімнатна", "3-кімнатна", "4-кімнатна"]}
                onChange={(event, newValue: string) => {
                    setNumOfRooms(newValue);
                }}
                onInputChange={(event, newInputValue) => {
                    setNumOfRooms(newInputValue);
                }}
                renderOption={(props, option, index) => {
                    const { key, ...restProps } = props;
                    return (
                        <Box
                            key={key}
                            {...restProps}
                            component="li"
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                padding: '8px 16px',
                                backgroundColor: '#f9f9f9',
                                '&:hover': {
                                    backgroundColor: '#810008 !important',
                                    cursor: 'pointer',
                                    color: 'white',
                                },
                            }}
                        >
                            {option}
                        </Box>
                    )
                }}
                renderInput={(params) => (
                    <CustomTextField
                        {...params}
                        label="Кількість кімнат"
                        value={numOfRooms}
                        onChange={(e) => setNumOfRooms(e.target.value)} // Corrected to update numOfRooms
                    />
                )}
            />

            <CustomAutocomplete
                disablePortal
                options={Array(15).fill("all").map((_, i) => (
                    i !== 0 ? { from: i * 10, to: i * 10 + 10 } : "all"
                ))}
                getOptionLabel={(option) =>
                    typeof option === "string" ? option : `${option.from}м² - ${option.to}м²`
                }
                onChange={(event, newValue: any) => {
                    setAreaaOfRealty(newValue);
                }}
                onInputChange={(event, newInputValue) => {
                    setAreaaOfRealty(newInputValue);
                }}
                renderOption={(props, option) => {
                    const truekey = `${option.from}-${option.to}`;
                    const { key, ...restProps } = props;

                    return (
                        <Box
                            key={truekey} // pass key directly to JSX
                            {...restProps} // spread the rest of props
                            component="li"
                            sx={{
                                display: 'flex',
                                alignItems: 'center',
                                padding: '8px 16px',
                                backgroundColor: '#f9f9f9',
                                '&:hover': {
                                    backgroundColor: '#810008 !important',
                                    cursor: 'pointer',
                                    color: 'white',
                                },
                            }}
                        >
                            {typeof option === "string" ? option : `${option.from}м² - ${option.to}м²`}
                        </Box>
                    );
                }}
                renderInput={(params) => (
                    <CustomTextField
                        {...params}
                        label="Площа"
                        value={areaaOfRealty}
                        onChange={(e) => setAreaaOfRealty(e.target.value)}
                    />
                )}
            />
            <TwoRadios setFirst={setisRental} argument1={"Оренда"} argument2={"Купівля"} />
            <div className='flex justify-end'>
                <CustomTextFieldWithoutAutocomplete
                    sx={{ width: 150 }}
                    label="Від-₴"
                    onChange={e => setFrom(filternums(e.target.value))}
                    value={from}
                />
            </div>
            <div className='flex justify-start'>
                <CustomTextFieldWithoutAutocomplete
                    label="До-₴"
                    sx={{ width: 150 }}
                    onChange={e => setTo(filternums(e.target.value))}
                    value={to}
                />
            </div>
            <div className="col-span-2 w-[100%] flex justify-center items-center">
                <Button
                    variant="contained"
                    type="submit"
                    sx={{
                        background: "#888888",
                        borderRadius: 5,
                        width: "50%",
                        paddingTop: "3%",
                        transition: "none",
                        paddingBottom: "3%",
                        border: "3px solid #888888",
                        color: "#B1000B",
                        '&:hover': {
                            borderColor: "#B1000B",
                        },
                    }}
                >
                    Шукати
                </Button>
            </div>
        </form>
    );
};

export default SearchForm;