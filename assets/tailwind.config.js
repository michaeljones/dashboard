module.exports = {
    purge: {
        content: ["../lib/**/*.html.eex", "../lib/**/view.ex"]
    },
    theme: {
        colors: {
            primary: "#355164",
            secondary: "var(--secondary)",
            "dark-blue": "#355164",
            "light-blue": "#bdebff",
            "mid-blue": "#1b6191",
            white: "white",
            "off-white": "var(--off-white)",
            "grey-1": "var(--grey-1)",
            "grey-2": "var(--grey-2)",
            "grey-3": "var(--grey-3)",
            "grey-4": "var(--grey-4)",
            "grey-5": "var(--grey-5)",
            "grey-6": "var(--grey-6)"
        },
        screens: {
            // We're not using any breakpoints yet
            // sm: '640px',
            // md: "768px"
            // lg: '1024px',
            // xl: '1280px',
        }
    },
    future: {
        removeDeprecatedGapUtilities: true
    }
};
