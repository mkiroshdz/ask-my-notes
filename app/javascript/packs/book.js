import React from "react";
import ReactDOM from 'react-dom/client';
import _ from 'underscore';

import App from "./components/app.jsx";

addEventListener("load", (e) => {
  const root = document.getElementById("app");
  const data = JSON.parse(root.dataset.book);
  // hsdfdfs
  
  ReactDOM.createRoot(root).render(
    <React.StrictMode>
      <App {..._.pick(data, 'title', 'author', 'slug', 'cover', 'questions')} />
    </React.StrictMode>
  );
});