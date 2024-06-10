import React, { useState } from 'react';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';

// Import Audios
import beep from '../assets/beep.mp3';
import deined from '../assets/denied.mp3';
import unlock from '../assets/unlock.mp3';
import { useNuiEvent } from '../hooks/useNuiEvent';

// This will set the NUI to visible if we are
// developing in browser
debugData([
    {
        action: 'setVisible',
        data: true,
    },
]);

const playKeypadSound = () => {
    const audio = new Audio(beep);
    audio.play();
};

const App: React.FC = () => {
    const [keypadState, setKeypadState] = useState<string>('');
    const [code, setCode] = useState<string>('1234');
    const [keypadId, setKeypadId] = useState<string>('');
    const [codeValidated, setCodeValidated] = useState<boolean>(false);
    const [codeState, setCodeState] = useState<boolean>(false);
    const [submitButtonEnabled, setSubmitButtonEnabled] =
        useState<boolean>(false);

    // Listen for our "uiCodeSetup" event
    // and set the code state
    useNuiEvent<{ doorId: string; code: string }>(
        'sticks_keypad:uiInit',
        (data) => {
            console.log('[sticks_keypad:nui::setDoorId] uiInit: init...');
            setCode(data.code);
            setKeypadId(data.doorId);

            console.log(
                '[sticks_keypad:nui::setDoorId] uiInit: doorId: ',
                data.doorId,
            );

            console.log('[sticks_keypad:nui::setDoorId] uiInit done');
        },
    );

    async function onCodeSubmit(data: string) {
        // Load both the denied and unlock audio
        const deniedAudio = new Audio(deined);
        const unlockAudio = new Audio(unlock);

        // Check if the data is equal to the code
        if (data === code) {
            // Play the unlock audio
            await unlockAudio.play();
            // Set the code state to true
            setCodeState(true);
            // Send the data to the server
            fetchNui('sticks_keypad:codeSubmitSuccess', {
                code: data,
                doorId: keypadId,
            });

            // Reset the keypad state
            setTimeout(() => {
                setKeypadState('');
                setCodeState(false);
                setSubmitButtonEnabled(false);
            }, 1000);
        } else {
            // Play the denied audio
            deniedAudio.play();
            setCodeValidated(true);
            setSubmitButtonEnabled(true);

            setTimeout(() => {
                setKeypadState('');
                setCodeValidated(false);
                setSubmitButtonEnabled(false);
            }, 1000);
        }
    }

    return (
        <div className='h-screen flex justify-center items-center bg-gray-900/40'>
            <div className='w-80 p-6 bg-zinc-800 rounded-lg shadow-lg'>
                <div className='text-3xl text-white mb-4 text-center'>
                    Enter Passcode
                </div>
                <div className='text-2xl text-white mb-4 text-center'>
                    {codeState
                        ? 'Unlocked'
                        : keypadState.length === code.length && codeValidated
                        ? 'Code is incorrect'
                        : keypadState}
                </div>
                <div className='grid grid-cols-3 gap-2 mb-4'>
                    {Array.from({ length: 9 }).map((_, i) => (
                        <button
                            key={i}
                            className='w-20 h-20 bg-zinc-700 hover:bg-zinc-700/40 duration-150 text-white text-2xl rounded-lg'
                            onClick={() => {
                                if (keypadState.length < code.length) {
                                    setKeypadState((prev) => prev + (i + 1));
                                    playKeypadSound();
                                }
                            }}
                        >
                            {i + 1}
                        </button>
                    ))}
                    <button
                        className='w-20 h-20 bg-zinc-700 hover:bg-zinc-700/40 duration-150 text-white text-2xl rounded-lg'
                        onClick={() => setKeypadState((prev) => prev + '0')}
                    >
                        0
                    </button>
                    <button
                        className='w-20 h-20 bg-zinc-700 hover:bg-zinc-700/40 duration-150 text-white text-2xl rounded-lg'
                        onClick={() =>
                            setKeypadState((prev) => prev.slice(0, -1))
                        }
                    >
                        DEL
                    </button>
                    <button
                        className='w-20 h-20 bg-zinc-700 hover:bg-zinc-700/40 duration-150 text-white text-2xl rounded-lg'
                        onClick={() => setKeypadState('')}
                    >
                        C
                    </button>
                </div>
                <button
                    className='w-full h-12 bg-green-600 hover:bg-green-700/80 duration-150 text-white text-2xl rounded-lg disabled:bg-gray-500 disabled:cursor-not-allowed'
                    onClick={() => onCodeSubmit(keypadState)}
                    disabled={
                        keypadState.length !== code.length ||
                        submitButtonEnabled
                    }
                >
                    Submit
                </button>
            </div>
        </div>
    );
};

export default App;
