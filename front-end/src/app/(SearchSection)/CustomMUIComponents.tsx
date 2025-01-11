import { Autocomplete, TextField, ToggleButtonGroup } from "@mui/material";
import styled from "styled-components";

const CustomToggleButtonGroup = styled(ToggleButtonGroup)({
    width: "100%",
    display: "flex",
    justifyContent: "space-evenly",
    gridColumn: "span 2 / span 2",
    flex: 1,
    '& .MuiToggleButton-root': {
        backgroundColor: '#888888',
        color: 'white',
        borderRadius: '8px',
        border: '1px solid #888888',
        '&:hover': {
            backgroundColor: '#B1000B',
            color: 'white',
        },
        '&.Mui-selected': {
            backgroundColor: '#B1000B',
            color: 'white',
            borderColor: '#B1000B',
        },
        '&.Mui-selected:hover': {
            backgroundColor: '#810008',
            borderColor: '#810008',
        },
    },
});

const CustomAutocomplete = styled(Autocomplete)({
    '& .MuiInputBase-root': {
        backgroundColor: '#888888',
        borderRadius: '15px',
    },
    '& .MuiOutlinedInput-notchedOutline': {
        borderWidth: 2.5,
        borderColor: '#888888',
    },
    '&:hover .MuiOutlinedInput-notchedOutline': {
        borderColor: '#B1000B',
        borderWidth: 2.5,
    },
    '& .Mui-focused .MuiOutlinedInput-notchedOutline': {
        borderWidth: 2.5,
        borderColor: '#B1000B',
    },
    '& .MuiAutocomplete-option': {
        backgroundColor: 'red',
        color: 'blue',
        borderRadius: '8px',
        '&:hover': {
            backgroundColor: '#B1000B',
            color: 'white',
        },
        '&.Mui-focused': {
            backgroundColor: 'blue',
            color: 'red',
        },
    },
});


const CustomTextField = styled(TextField)({
    '& .MuiInputLabel-root': {
        color: '#B1000B',
    },
    '& .MuiInputLabel-root.Mui-focused': {
        color: '#B1000B',
        fontSize: "1.2em"
    },
});

const CustomTextFieldWithoutAutocomplete = styled(TextField)({
    '& .MuiInputBase-root': {
        backgroundColor: '#888888',
        borderRadius: '15px',
    },
    '& .MuiOutlinedInput-notchedOutline': {
        borderWidth: 2.5,
        borderColor: '#888888',
    },
    '&:hover .MuiOutlinedInput-notchedOutline': {
        borderColor: '#B1000B',
        borderWidth: 2.5,
    },
    '& .Mui-focused .MuiOutlinedInput-notchedOutline': {
        borderWidth: 2.5,
        borderColor: '#B1000B',
    },
    '& .MuiAutocomplete-option': {
        backgroundColor: 'red',
        color: 'blue',
        borderRadius: '8px',
        '&:hover': {
            backgroundColor: '#B1000B',
            color: 'white',
        },
        '&.Mui-focused': {
            backgroundColor: 'blue',
            color: 'red',
        },
    },
    '& .MuiInputLabel-root': {
        color: '#B1000B',
        fontSize: "1.2em",

    },
    '& .MuiInputLabel-root.Mui-focused': {
        color: '#B1000B',
    },
});




export { CustomTextField, CustomAutocomplete, CustomToggleButtonGroup, CustomTextFieldWithoutAutocomplete }