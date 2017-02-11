import React from 'react';
import ReactDOM from 'react-dom';

import styles from 'styles.css';

const Config = {
    protocol: __API_PROTOCOL__,
    host: __API_HOST__,
    port: __API_PORT__
}

const Application = (props) => {
    return (
        <div id="app">
            <Introduction />
            <Messages messages={props.messages} />
        </div>
    )
}

const Introduction = () => (
    <div className="headline">
        <h1>Welcome to <strong>famly/plan</strong></h1>
        <p>
            Plan helps you automate your development environment.
            This is just a very simple app to help you get the feel of how it works.
            The application displays messages that it gets from a Python backend.
            The backend reads messages from a MySQL database.
            To add new messages you have to add SQL migration scripts.
        </p>
        <hr />
    </div>
);

const Messages = ({messages}) => {
    if (messages.length === 0) {
        return <div>
            <p>
                No messages yet.
            </p>
            <p>
                Here's how you can create a message.
                Create a file named <strong>2-add-message.sql</strong> inside of
                <strong>.services/migrations/sql</strong> with the following contents.
            </p>
            <pre>INSERT INTO messages (message) values ('Your First Message!!');</pre>
            <p>
                Then refresh your browser.
            </p>
        </div>
    }
    return (
        <ul>
            {messages.map(message =>
                <li key={message.messageId}>
                    {message.text}
                </li>
            )}
        </ul>
    );
}

const Loading = () => {
    return (
        <h1>Loading...</h1>
    )
}

ReactDOM.render(
    <Loading />,
    document.getElementById('root')
);

window.setTimeout(() => {
    fetch(`${Config.protocol}://${Config.host}:${Config.port}/`)
        .then(response => response.json())
        .then(messages => {
            ReactDOM.render(
                <Application messages={messages} />,
                document.getElementById('root')
            );
        })
        .catch(e => console.error(e));
}, 200)
